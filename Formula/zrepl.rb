class Zrepl < Formula
  desc "One-stop ZFS backup & replication solution"
  homepage "https://zrepl.github.io"
  url "https://github.com/zrepl/zrepl/archive/v0.6.0.tar.gz"
  sha256 "0bf1dcf634a43af81cd9a0d7b9ae65f63a5938c35d3e6cd804177c8db52929f4"
  license "MIT"
  head "https://github.com/zrepl/zrepl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f43f61ea51db0d619e1be5e889e00f2237dc40c8529cf7bb470ae84bc6628ffb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "78b4b5efe5764faedaed4b66d6099be51f35b78f3ae62348e143cc51b8109a31"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f69fbb9c9aeaa2dbc2f1cebdeaec0f9108c40b9d74615d80afa5ffcfb03648ad"
    sha256 cellar: :any_skip_relocation, ventura:        "4ff1d78151426b9f1f5a3149e12f4d55a1a0ae23ebb7fb2cb8a10a6164be3c01"
    sha256 cellar: :any_skip_relocation, monterey:       "cf954a340c8e55c54dcaf13cc928551c579f306138c673a0c66cbfc6d83053e3"
    sha256 cellar: :any_skip_relocation, big_sur:        "0e72ac1fb2b5fdf3a2711e2363e0ef999feeb742f21c64f4966632f5f0700d25"
    sha256 cellar: :any_skip_relocation, catalina:       "bde1dbd82033d10cc2d23df40c8a7b33a0db666763b3c0e82ce9735691bd9d6f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "825c2d421d4690af7640e7444eab42a8e252a9a2644848b1241c908335c21e43"
  end

  depends_on "go" => :build

  resource "homebrew-sample_config" do
    url "https://raw.githubusercontent.com/zrepl/zrepl/master/config/samples/local.yml"
    sha256 "f27b21716e6efdc208481a8f7399f35fd041183783e00c57f62b3a5520470c05"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/zrepl/zrepl/version.zreplVersion=#{version}")
  end

  def post_install
    (var/"log/zrepl").mkpath
    (var/"run/zrepl").mkpath
    (etc/"zrepl").mkpath
  end

  plist_options startup: true
  service do
    run [opt_bin/"zrepl", "daemon"]
    keep_alive true
    working_dir var/"run/zrepl"
    log_path var/"log/zrepl/zrepl.out.log"
    error_log_path var/"log/zrepl/zrepl.err.log"
    environment_variables PATH: std_service_path_env
  end

  test do
    resources.each do |r|
      r.verify_download_integrity(r.fetch)
      assert_equal "", shell_output("#{bin}/zrepl configcheck --config #{r.cached_download}")
    end
  end
end
