class ApplicationResource < JSONAPI::Resource
  class << self
    # TODO: make this an extensable module and move to lib (or helpers)
    def comparison_filter_for(target_attribute)
      target_attribute = target_attribute.to_sym
      comparative_tokens = { _default: :eq, eq: :eq , gte: :gteq, gt: :gt, lt: :lt, lte: :lteq }

      ->(records, value, _options) {
        provided_params = value[0].split(' ') # ['2020-01-13T15:37:23-05:00'] or ['gte', '2020-01-13T15:37:23-05:00']

        case provided_params.size
        when 1
          filter_operator = comparative_tokens[:_default]
          filter_value = provided_params[0]
        when 2
          filter_operator = comparative_tokens[provided_params[0].to_sym] || comparative_tokens[:_default]
          filter_value = provided_params[1]
        else
          # TODO: Throw error for bad params (lookup JSON:API status code and JSON:API Resource error format)
        end

        records.where(self._model_class.arel_table[target_attribute].send(filter_operator, filter_value))
      }
    end

    def updatable_fields(context)
      super - [:created_at, :updated_at]
    end

    def creatable_fields(context)
      super - [:created_at, :updated_at]
    end
  end

  abstract
  attributes :created_at, :updated_at

  before_create :authorize_create
  before_update :authorize_update

  def authorize_create
    unless Pundit.policy!(context.user, @model).create?
      raise_forbidden("Not authorized to create #{@model.class.name.pluralize}")
    end
  end

  def authorize_update
    unless Pundit.policy!(context.user, @model).update?
      raise_forbidden("Not authorized to update #{@model.class.name.pluralize}")
    end
  end

  private

  def raise_forbidden(message)
    raise Pundit::NotAuthorizedError, message
  end
end
