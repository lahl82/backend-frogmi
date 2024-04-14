class RefreshEarthquakeFeaturesJob
  include Sidekiq::Job

  def perform(*args)
    Features::EntryPoint.call

    puts 'Earthquake Features refreshed!'
  end
end
