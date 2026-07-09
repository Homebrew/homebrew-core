class Zrepl < Formula
  desc "One-stop ZFS backup & replication solution"
  homepage "https://zrepl.github.io"
  url "https://github.com/zrepl/zrepl/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "d451ad1d05a0afdc752daf1dada9327aa338f691eca91e1c8fc9828eebd89757"
  license "MIT"
  head "https://github.com/zrepl/zrepl.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "18a19ca879a02097dc1cb1d0dd2b72b4addc92c1405be553d80b8090580a4610"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "53cc9ad155f92938fdd6504bf130c16d043186c7fe8ff1b250bd4ede6307f3f6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5158b93a06a125e57955961a9a7ec6c230e97c1616b1eb0999a3e9cc3b2c5f28"
    sha256 cellar: :any_skip_relocation, sonoma:        "ccf68bab0f5328baf50cbbb7a5e6480d49c36a284d896f54b28a07b0ac7178fe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f5bc39a2b366b2db30b75c84100fd2252798124f1854afa3123b8043b5989975"
    sha256 cellar: :any,                 x86_64_linux:  "c196abef74589bc16a49dbbfa20909f59cf92bb9951d1848e1cac5be32d8a9b3"
  end

  depends_on "go" => :build

  resource "homebrew-sample_config" do
    url "https://raw.githubusercontent.com/zrepl/zrepl/refs/tags/v0.6.1/config/samples/local.yml"
    sha256 "f27b21716e6efdc208481a8f7399f35fd041183783e00c57f62b3a5520470c05"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/zrepl/zrepl/version.zreplVersion=#{version}")
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
