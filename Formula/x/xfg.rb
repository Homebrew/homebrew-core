class Xfg < Formula
  desc "Sovereign private blockchain banking node suite"
  homepage "https://usexfg.org"
  url "https://github.com/usexfg/fuego-suite/archive/refs/tags/1.10.06.tar.gz"
  sha256 "f27cf99358268296579caef1910f01524113419a2bfdf39492d6a614bbfdf505"
  license "GPL-3.0-or-later"

  depends_on "cmake" => :build
  depends_on "boost@1.85"
  depends_on "openssl@3"
  depends_on "icu4c"
  depends_on "jsoncpp"

  conflicts_with "fuego"

  def install
    system "cmake", "-B", "build", "-DCMAKE_BUILD_TYPE=Release", *std_cmake_args
    system "cmake", "--build", "build", "-j", Hardware::CPU.cpus
    system "cmake", "--install", "build"
    cd "tui" do
      system "go", "build", "-o", bin/"fuego-tui"
    end
    cd "swapxfg" do
      system "go", "build", "-o", bin/"swapxfg", "."
    end
  end

  test do
    # Verify wallet CLI can create a testnet wallet (no running node needed)
    wallet_path = testpath/"test_wallet.bin"
    system "#{bin}/fire_wallet", "--testnet", "--generate-new-wallet", wallet_path.to_s,
           "--password", "test_password"
    assert_predicate wallet_path, :exist?

    # Verify daemon responds to valid arguments
    assert_match "Fuego", shell_output("#{bin}/fuegod --help 2>&1", 1)
  end
end
