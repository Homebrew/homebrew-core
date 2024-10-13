class Zrepl < Formula
  desc "One-stop ZFS backup & replication solution"
  homepage "https://zrepl.github.io"
  url "https://github.com/zrepl/zrepl/archive/refs/tags/v0.6.1.tar.gz"
  sha256 "263c82501b75a1413f8a298c1d67d7e940c1b0cb967979790773237e2a30adbd"
  license "MIT"
  head "https://github.com/zrepl/zrepl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "467d9021d507942a4f74a1c64983a1a216e3215110b67ca591101a1350a93928"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cb2b36b880afd2cf11fc4bbb7e2f544f40287e180bdd06c47da63be1c9bb2970"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aedcf0ebb00175cef1e063bddb652c1d291c5c388a90878ec95719cd5ed93a04"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3c301f823c74d52657a946000964f3b4a3089a0a914deb6cf68f69d150ee057c"
    sha256 cellar: :any_skip_relocation, sonoma:         "b96ec21a1745a2b7eac7265f8db9e342c6ec01ddc2c7e3a9b7d7c24f2cbe0687"
    sha256 cellar: :any_skip_relocation, ventura:        "d09931af39605cdf1215017138bda34463802609db9c72cf61a22d9918b323c4"
    sha256 cellar: :any_skip_relocation, monterey:       "80344778b7d3a7007e38e86e066541a53796b318673eba51d869095e49935a3c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "67d6e26dd731da07445fa18d19f25c41c5ca41e48d9c829f92e1f7f487143fd2"
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
      assert_equal "", shell_output("#{bin}/zrepl configcheck --config #{r.cached_download}")
    end
  end
end
