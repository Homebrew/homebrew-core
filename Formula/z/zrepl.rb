class Zrepl < Formula
  desc "One-stop ZFS backup & replication solution"
  homepage "https://zrepl.github.io"
  url "https://github.com/zrepl/zrepl/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "d451ad1d05a0afdc752daf1dada9327aa338f691eca91e1c8fc9828eebd89757"
  license "MIT"
  head "https://github.com/zrepl/zrepl.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5e49cd8656a732120b3372c27730edcdfcd8fd7b27329bf030d31dc41a7c5214"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "335eee4c13bf862fc84af998944929f36435895475ad50f4191d929d83f9d669"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8e8d1a17b44b0c9eba415440cb7e643814a223b5270796e16f2f1b4c9073d95e"
    sha256 cellar: :any_skip_relocation, sonoma:        "04fa28a458e199055ab473c4e799953708d595f94034f437933fc42fa8300b68"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "06f056a22b705129d9d5aa851bec59bfc2a00f46b0a585b1840dfaf9ac69652a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "60c673e4fbe421ad7d42796f566d7bd7a062882584a3b3505b5757b50952bd24"
  end

  depends_on "go" => :build

  resource "homebrew-sample_config" do
    url "https://raw.githubusercontent.com/zrepl/zrepl/refs/tags/v0.6.1/config/samples/local.yml"
    sha256 "f27b21716e6efdc208481a8f7399f35fd041183783e00c57f62b3a5520470c05"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/zrepl/zrepl/version.zreplVersion=#{version}")
    (var/"log/zrepl").mkpath
    (var/"run/zrepl").mkpath
    (etc/"zrepl").mkpath

    generate_completions_from_executable(bin/"zrepl", shell_parameter_format: :cobra)
  end

  service do
    run [opt_bin/"zrepl", "daemon"]
    keep_alive true
    require_root true
    working_dir var/"run/zrepl"
    log_path var/"log/zrepl/zrepl.out.log"
    error_log_path var/"log/zrepl/zrepl.err.log"
    environment_variables PATH: std_service_path_env
  end

  test do
    resources.each do |r|
      r.verify_download_integrity(r.fetch)
      assert_empty shell_output("#{bin}/zrepl configcheck --config #{r.cached_download}")
    end
  end
end
