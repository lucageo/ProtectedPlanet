require 'test_helper'

class ImportWorkerTest < ActiveSupport::TestCase
  test '#perform_async increases the number of total tasks for the current import' do
    ImportWorker.any_instance.stubs(:perform)

    import_mock = mock()
    import_mock.expects(:increase_total_jobs_count)
    ImportTools.stubs(:current_import).returns(import_mock)

    ImportWorker.perform_async
  end

  test '.finalise_job increases the number of completed jobs for the current import' do
    import_mock = mock()
    import_mock.stubs(:completed?).returns(false)
    import_mock.expects(:increase_completed_jobs_count)

    ImportTools.stubs(:current_import).returns(import_mock)

    ImportWorker.new.finalise_job
  end

  test '.finalise_job finalises the import if this is completed' do
    import_mock = mock()
    import_mock.stubs(:increase_completed_jobs_count)
    import_mock.stubs(:completed?).returns(true)
    import_mock.expects(:finalise)

    ImportTools.stubs(:current_import).returns(import_mock)

    ImportWorker.new.finalise_job
  end
end