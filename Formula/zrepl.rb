class Zrepl < Formula
  desc "One-stop ZFS backup & replication solution"
  homepage "https://zrepl.github.io"
  url "https://github.com/zrepl/zrepl/archive/v0.4.0.tar.gz"
  sha256 "e7035a8a40913614f4ab24d7caad2c26419fd2b0aaa3565c16439e59214ae590"
  license "MIT"
  head "https://github.com/zrepl/zrepl.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "303024f00388a2fced254a52a56017c6d65b75abf2a49868a23bf1d6110d5a9f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5f7aabb2340c6245bd76de2658f2d85eefa4892787a51de411d1c5fa0e273a70"
    sha256 cellar: :any_skip_relocation, monterey:       "7b7b42323528cfa48114e2e7bfe0e18d78ff76708099e822c25ee91d4696fc74"
    sha256 cellar: :any_skip_relocation, big_sur:        "21706026893bdb3aef1e8b66237d500fefc92519538491d212cea68616b01e1d"
    sha256 cellar: :any_skip_relocation, catalina:       "2725ffa8a53c33564c61e6906bfe93a0c5e510b919757822b66ccec025b251d5"
    sha256 cellar: :any_skip_relocation, mojave:         "0341ef3fdd925a2507f7d265dee147dc3a4a7249e5da86312abec05281b500fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fa323fd542fdda26c040680679bcaf452306e653a91aeac5a20ca0569ff6d3fc"
  end

  depends_on "go" => :build

  resource "sample_config" do
    url "https://raw.githubusercontent.com/zrepl/zrepl/master/config/samples/local.yml"
    sha256 "f27b21716e6efdc208481a8f7399f35fd041183783e00c57f62b3a5520470c05"
  end

  def install
    system "go", "build", *std_go_args,
      "-ldflags", "-X github.com/zrepl/zrepl/version.zreplVersion=#{version}"
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
