class Sdns < Formula
  desc "Privacy important, fast, recursive dns resolver server with dnssec support"
  homepage "https://sdns.dev/"
  url "https://github.com/semihalev/sdns/archive/refs/tags/v1.6.6.tar.gz"
  sha256 "89f75fc353cf8026cbfa4b51aa2499e7e7c413a44f675112c42dfbc0bbcbe7c6"
  license "MIT"
  head "https://github.com/semihalev/sdns.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d57544aaf5b5a4fcf0b8e8014d04e5b4bc9432e6f35f4bace76755ed78d03717"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c252c5a374873f8c230c608d6d060af07ae6f3e264cdcab153c0a9711d8e607b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ad4613e6c4dbc184e65c7a99cc2ae3bef69721d058a2ce1ffb803329e76646c3"
    sha256 cellar: :any_skip_relocation, sonoma:        "b377089a9620eeb683d20539e7a245102365f2e62a19a15dfee924e2c3210d04"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "34b770bdedb2bb7624c20e4f8f33c78cc098914b63d74fbf6ccceee8430bea72"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fa3ef489d494c396c9fc8ef371af97f0f5300669f2f65c25b6120eaf3dea573f"
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
