class Zrepl < Formula
  desc "One-stop ZFS backup & replication solution"
  homepage "https://zrepl.github.io"
  url "https://github.com/zrepl/zrepl/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "d451ad1d05a0afdc752daf1dada9327aa338f691eca91e1c8fc9828eebd89757"
  license "MIT"
  head "https://github.com/zrepl/zrepl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "208277fa477884e0419b882934545194b9cc42f94b429bb94cec29095f8294de"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "83603ff9603be60833fc8448a17a35eaf01598a52b467335225cc46c470e14e1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bdfdc9ae054e19a5976218ec1e94ca3e777bd4c7125858aadd3c0c4ab3a20be5"
    sha256 cellar: :any_skip_relocation, sonoma:        "65f3263bab397da62393bedef12b5b8ed811e0cd747f57fad5bbf7f89c4683d6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bbf631d984241bf60b21e381ed24570835fa12a40ba3840fdbd73bbda4f8ae26"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "97a0feee7878c048a4e3a54f09a4706d433ac1cef303f42e278b074a8f86b84d"
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
