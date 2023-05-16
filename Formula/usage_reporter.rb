# Documentation: https://docs.brew.sh/Formula-Cookbook
#                https://rubydoc.brew.sh/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!
class UsageReporter < Formula
  desc "a tool can print the usage of cpu and memory for a process"
  homepage "https://github.com/cuishuang/usage_reporter"
  url "https://github.com/cuishuang/usage_reporter/archive/refs/tags/v0.01.tar.gz"
  sha256 "04407921653439b54e9b5d8a0c912b143bddde1a27a6392be2232cbf6af45291"
  license "Apache License"

  # depends_on "cmake" => :build
  depends_on "go" => :build

  def install
    # ENV.deparallelize  # if your formula fails when building in parallel
    # Remove unrecognized options if warned by configure
    # https://rubydoc.brew.sh/Formula.html#std_configure_args-instance_method
    #system "./configure", *std_configure_args, "--disable-silent-rules"
    ENV["GOPROXY"] = "https://goproxy.cn,direct"
    system "go", "build", "-o", bin/"usage_reporter"
    # system "cmake", "-S", ".", "-B", "build", *std_cmake_args
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! For Homebrew/homebrew-core
    # this will need to be a test that verifies the functionality of the
    # software. Run the test with `brew test usage_reporter`. Options passed
    # to `brew install` such as `--HEAD` also need to be provided to `brew test`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system "#{bin}/program", "do", "something"`.
    #system "false"
    status_output = shell_output("#{bin}/usage_reporter -t -1", 1)
    assert_match "timeInterval must gte 0", status_output
  end
end
