class Sdns < Formula
  desc "Privacy important, fast, recursive dns resolver server with dnssec support"
  homepage "https://sdns.dev/"
  url "https://github.com/semihalev/sdns/archive/refs/tags/v1.8.0.tar.gz"
  sha256 "351df507dea8577bde74d2178d89d1cddb34c94a90695ff66ac63b755c2c83ae"
  license "MIT"
  head "https://github.com/semihalev/sdns.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "70167053dc21847e6245db7dca8f8d9deef5a94cd06b7e4f5becb84ca627f858"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cff1d2eefa14850a9f85cd90632c6c298ae04a849583d177a660c372aa4a0cf7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f3ed087fccbe2104cd494f493a6d72168d7117b6c5fd9966b1d99a5caca98416"
    sha256 cellar: :any_skip_relocation, sonoma:        "82b1ce3d9a3c2cc213c7d23101076209d6988df34ea1112d4741a34638413130"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f7e5e54cfb35586a58206ab399e5b458e2fa32bba30fe11af6a22fc4e55be8bf"
    sha256 cellar: :any,                 x86_64_linux:  "45300f4a4b00827b0c6973473d725ec89a81d53ff660fafe389684c9a7e78eb9"
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
