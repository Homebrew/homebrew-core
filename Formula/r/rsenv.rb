class Rsenv < Formula
  desc "Developer Environments Evolved"
  homepage "https://github.com/sysid/rs-env"
  url "https://github.com/sysid/rs-env/archive/refs/tags/v5.1.2.tar.gz"
  sha256 "15874e92ee98f13afa826c898b97b2db19b79ecfb2b896f521ff1f145fd07496"
  license "BSD-3-Clause"
  head "https://github.com/sysid/rs-env.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  def install
    cd "rsenv" do
      # Ensure that the `openssl` crate picks up the intended library.
      # https://docs.rs/openssl/latest/openssl/#manual
      ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix

      system "cargo", "install", *std_cargo_args
    end

    generate_completions_from_executable(bin/"rsenv", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rsenv --version")

    expected_output = "Vault:   (not initialized)"
    assert_match expected_output, shell_output("#{bin}/rsenv info 2>&1")
  end
end
