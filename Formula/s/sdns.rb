class Sdns < Formula
  desc "Privacy important, fast, recursive dns resolver server with dnssec support"
  homepage "https://sdns.dev/"
  url "https://github.com/semihalev/sdns/archive/refs/tags/v1.7.2.tar.gz"
  sha256 "a611113e24dfe765b9bacb557f5cea7edde310495039f859786baea6cadaf1a9"
  license "MIT"
  head "https://github.com/semihalev/sdns.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "908d908a975c0f09dd913d518ecab6422a4a50a216ac7de2707f84d40ba1b219"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0f25533ed99711ccb89d10b4a50fcd6936436beb423fe022dde4bedd87324bb9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b4e0c26b048670ae58aa2249d44438e3dea44319868bac0eec75d6e362d68906"
    sha256 cellar: :any_skip_relocation, sonoma:        "fa9c4ce39c202fa9da244a9a3bf46888e6b53f489b8fb1d2119252c350f0d359"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0db6d0488c62254e8a32b5deafabae042d83ca7f75570b9045733d61148659a9"
    sha256 cellar: :any,                 x86_64_linux:  "c5af80a6dd664a2ef9a6e9d4f20c1695cb7f194a7c00a2bff1cc18cc42d974c3"
  end

  depends_on "go" => :build

  def install
    system "make", "build"
    bin.install "sdns"
  end

  service do
    run [opt_bin/"sdns", "--config", etc/"sdns.conf"]
    keep_alive true
    require_root true
    error_log_path var/"log/sdns.log"
    log_path var/"log/sdns.log"
    working_dir opt_prefix
  end

  test do
    spawn bin/"sdns", "--config", testpath/"sdns.conf"
    sleep 2
    assert_path_exists testpath/"sdns.conf"
  end
end
