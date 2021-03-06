module Spree
  module Admin
    module Products
      class IssuesController < Spree::Admin::BaseController
        before_filter :load_product
        before_filter :load_issue, :only => [:show, :edit, :update, :ship, :unship]
        before_filter :load_products, :except => [:show, :index]

        def show
          if @issue.shipped?
            @product_subscriptions = Subscription.where(id: @issue.shipped_issues.pluck(:subscription_id)).includes(:ship_address)
          else
            @product_subscriptions = @product.subscriptions.eligible_for_shipping.includes(:ship_address)
          end
          respond_to do |format|
            format.html
            format.pdf do
              addresses_list = @product_subscriptions.map { |s| s.ship_address }
              labels = IssuePdf.new(addresses_list, view_context)
              send_data labels.document.render, filename: "#{@issue.name}.pdf", type: "application/pdf", disposition: "inline"
            end
          end
        end

        def index
          @issues = Issue.where(product_id: @product.id)
        end

        def update
          if @issue.update_attributes(issue_params)
            flash[:notice] = Spree.t('issue_updated')
            redirect_to admin_product_issue_path(@product, @issue)
          else
            flash[:error] = Spree.t(:issue_not_updated)
            render action: :edit
          end
        end

        def new
          @issue = @product.issues.build
        end

        def create
          @issue = @product.issues.create(issue_params)

          if @issue.persisted?
            flash[:notice] = Spree.t('issue_created')
            redirect_to admin_product_issue_path(@product, @issue)
          else
            flash[:error] = Spree.t(:issue_not_created)
            render :new
          end
        end

        def destroy
          @issue = Issue.find(params[:id])
          @issue.destroy

          flash[:success] = Spree.t('issue_deleted')

          respond_with(@issue) do |format|
            format.html { redirect_to admin_product_issues_path(@issue.product) }
            format.js  { render_js_for_destroy }
          end
        end

        def ship
          if @issue.shipped?
            flash[:error]  = Spree.t('issue_not_shipped')
          else
            @issue.ship!
            flash[:notice]  = Spree.t('issue_shipped')
          end
          redirect_to admin_product_issues_path(@product)
        end

        def unship
          if @issue.shipped?
            @issue.unship!
            flash[:notice]  = Spree.t('issue_unshipped')
          else
            flash[:error]  = Spree.t('issue_not_shipped')
          end
          redirect_to admin_product_issues_path(@product)
        end

        private

        def load_product
          @product = Product.with_deleted.find_by_slug(params[:product_id])
        end

        def load_issue
          @issue = Issue.find(params[:id])
        end

        def load_products
          @products = Product.subscribable
        end

        def issue_params
          params.require(:issue).permit(:name, :published_at, :shipped_at, :product, :product_issue_id)
        end
      end
    end
  end
end
