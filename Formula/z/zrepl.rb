class Zrepl < Formula
  desc "One-stop ZFS backup & replication solution"
  homepage "https://zrepl.github.io"
  url "https://github.com/zrepl/zrepl/archive/refs/tags/v0.6.1.tar.gz"
  sha256 "263c82501b75a1413f8a298c1d67d7e940c1b0cb967979790773237e2a30adbd"
  license "MIT"
  head "https://github.com/zrepl/zrepl.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "86f94f15cab96087e5f9a17e02756dc1efe8f382635805345d6da7cf4f15a810"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "86f94f15cab96087e5f9a17e02756dc1efe8f382635805345d6da7cf4f15a810"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "86f94f15cab96087e5f9a17e02756dc1efe8f382635805345d6da7cf4f15a810"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "86f94f15cab96087e5f9a17e02756dc1efe8f382635805345d6da7cf4f15a810"
    sha256 cellar: :any_skip_relocation, sonoma:        "0f47b589d4c5a01d645191e7963fc4e62a018f1844b22a3acfec0275354a294d"
    sha256 cellar: :any_skip_relocation, ventura:       "0f47b589d4c5a01d645191e7963fc4e62a018f1844b22a3acfec0275354a294d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9d264994b4417c3509cebcfb4b04bc6e2a88e7926d93ab6950fc8e3d5893ded0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2db65d9638d95007c9b4880052f58a08befe29686120bd8fb33d9998a214ce49"
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
