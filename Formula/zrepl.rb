class Zrepl < Formula
  desc "One-stop ZFS backup & replication solution"
  homepage "https://zrepl.github.io"
  url "https://github.com/zrepl/zrepl/archive/v0.5.0.tar.gz"
  sha256 "4acfde9e7a09eca2de3de5c7d2987907ae446b345b69133e4b3c58a99c294465"
  license "MIT"
  head "https://github.com/zrepl/zrepl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0c8d9fd289790fce71ff766f4ba508841b26b07c9646c86c0f58d934b434a98a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "91da92f9974cacb35d64a0d84c20c6a02eb5c5ebdfc879bff968c883177e3298"
    sha256 cellar: :any_skip_relocation, monterey:       "36ad9cad7ba5fdabf65461dd637a4cb05028a93c332b440d7f95409067d89dce"
    sha256 cellar: :any_skip_relocation, big_sur:        "9a54101a9d020f333e5183d372ffbd743ffc0a702cd59f9abc284d2fd2890aa8"
    sha256 cellar: :any_skip_relocation, catalina:       "a4369b90960452b045f6d3879a2177c540fa3e42a6d18b3a567240c92c2a4772"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a615f406414dd1eed10a32de0cdae83f74b13de612ac0103248f0639ea962f43"
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
