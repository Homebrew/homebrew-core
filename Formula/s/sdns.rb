class Sdns < Formula
  desc "Privacy important, fast, recursive dns resolver server with dnssec support"
  homepage "https://sdns.dev/"
  url "https://github.com/semihalev/sdns/archive/refs/tags/v1.6.0.tar.gz"
  sha256 "1df9b0f18d2cca65dc1997159d1c529c8a4a1b19762d4e07017f5bc7ae901811"
  license "MIT"
  head "https://github.com/semihalev/sdns.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d4c16d068891027f263d505b3f9cac7b6d0330d9829861bab63386e7a9b9d59c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dde946dba2f7a1c0f31d436e09eac8d3a02c91e568ef4d341a6f565c66ecb441"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c940f9ccd89eb8dba9f2fbe63c237cf32c734be1d7132dcfa9f9c4ba8e3a60c7"
    sha256 cellar: :any_skip_relocation, sonoma:        "d5d0859f7c9852069869233f9847e7c2f0a5534897dc1f475bcc3b99549dee57"
    sha256 cellar: :any_skip_relocation, ventura:       "f237a979c49b0f4e602a96f1236ceef3401f065f451fa4f8dd36f300ee664e33"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "506ca34cb4fc9f2c653dea2a0dbb42cbddb48357d84b71f8ac866a740e1e6feb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "080dc545bbe7a8305c55a0cbf21c4db8f521dd163ae039afb410d0b78156a0fb"
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
