# frozen_string_literal: true

class SolidusAdmin::Users::Edit::Component < SolidusAdmin::BaseComponent
  include SolidusAdmin::Layout::PageHelpers

  def initialize(user:)
    @user = user
  end

  def form_id
    @form_id ||= "#{stimulus_id}--form-#{@user.id}"
  end

  def tabs
    [
      {
        text: t('.account'),
        href: solidus_admin.user_path(@user),
        current: action_name == "edit",
      },
      {
        text: t('.addresses'),
        href: solidus_admin.addresses_user_path(@user),
        current: action_name == "addresses",
      },
      {
        text: t('.order_history'),
        href: solidus_admin.orders_user_path(@user),
        current: action_name == "orders",
      },
      {
        text: t('.items'),
        href: spree.items_admin_user_path(@user),
        # @todo: update this "current" logic once folded into new admin
        current: action_name != "edit",
      },
      {
        text: t('.store_credit'),
        href: spree.admin_user_store_credits_path(@user),
        # @todo: update this "current" logic once folded into new admin
        current: action_name != "edit",
      },
    ]
  end

  def last_login(user)
    return t('.last_login.never') if user.try(:last_sign_in_at).blank?

    t(
      '.last_login.login_time_ago',
      # @note The second `.try` is only here for the specs to work.
      last_login_time: time_ago_in_words(user.try(:last_sign_in_at))
    ).capitalize
  end

  def role_options
    Spree::Role.all.map do |role|
      { label: role.name, id: role.id }
    end
  end
end
