# Documentation: https://docs.brew.sh/Formula-Cookbook
#                https://rubydoc.brew.sh/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!
class Temporalite < Formula
  desc "An experimental distribution of Temporal that runs as a single process"
  homepage "https://github.com/temporalio/temporalite"
  url "https://github.com/temporalio/temporalite/archive/v0.3.0.tar.gz"
  sha256 "a4980cca9b265694dca97e696fbe9136b2bb4ceecfc44a43cfc7d1ac55a3009b"
  license "MIT"

  depends_on "go" => :build

  def install
    # ENV.deparallelize  # if your formula fails when building in parallel
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/temporalite"
  end

  test do
    run_output = shell_output("#{bin}/temporalite --version")
    assert_match "temporalite version #{version}", run_output
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! For Homebrew/homebrew-core
    # this will need to be a test that verifies the functionality of the
    # software. Run the test with `brew test temporalite`. Options passed
    # to `brew install` such as `--HEAD` also need to be provided to `brew test`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system "#{bin}/program", "do", "something"`.
    #system "false"
  end
end
