module Services
  class Base
    extend ActiveModel::Callbacks

    define_model_callbacks :perform

    def call
      run_callbacks :perform do
        perform
      end
    end

    def perform
      raise NotImplementedError
    end
  end

  class ServiceError < StandardError; end
end
