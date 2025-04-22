class Sdns < Formula
  desc "Privacy important, fast, recursive dns resolver server with dnssec support"
  homepage "https://sdns.dev/"
  url "https://github.com/semihalev/sdns/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "0ab9d6a7ad3ae13688a10bae0b0738ca0089c81c1c7af9febcb3335f9d0aeadc"
  license "MIT"
  head "https://github.com/semihalev/sdns.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8879f8051f9fcda4339f0858b235382cfb0a65b494da5ce24e12eaa56fa8d6f1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b5a9fa5686de687d6204a8b30f0657a3cb141b5335c4d6c79c2dea41a439aaa3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0e704009281c8d500596e10e6210a3f440ed667315c5e62169bb84aa022a8b87"
    sha256 cellar: :any_skip_relocation, sonoma:        "838b9c51f9b668d478df8b3361509d5aae4313f5966a571ef35aa40448d5029f"
    sha256 cellar: :any_skip_relocation, ventura:       "4f679204866d04a4ea2e2ea11b15c36529495b750ac7036ca9bcc23006331508"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "78f1646258a3c18aa81544897254a79994824fce14fbf8bdcc1061c36ba8278c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8124cce9441d54dc25ef3783f90e047e346e5799e44ff0222acf73061a99df18"
  end

  depends_on "go" => :build

  def install
    system "make", "build"
    bin.install "sdns"
  end

  service do
    run [opt_bin/"sdns", "-config", etc/"sdns.conf"]
    keep_alive true
    require_root true
    error_log_path var/"log/sdns.log"
    log_path var/"log/sdns.log"
    working_dir opt_prefix
  end

  test do
    fork do
      exec bin/"sdns", "-config", testpath/"sdns.conf"
    end
    sleep(2)
    assert_path_exists testpath/"sdns.conf"
  end
end
