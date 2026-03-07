class Rai < Formula
  desc "Run AI instructions directly from your terminal, scripts, and CI/CD pipelines"
  homepage "https://appmakes.github.io/Rai/"
  version "1.1.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/appmakes/Rai/releases/download/v#{version}/rai-aarch64-apple-darwin.tar.gz"
      sha256 "119ba451b78f3b72d2a69650848b5ed6da684379ee7f7d84a17de15d21166245"
    else
      url "https://github.com/appmakes/Rai/releases/download/v#{version}/rai-x86_64-apple-darwin.tar.gz"
      sha256 "87a76802730c7f5e410f08302344feb3d623aa6f765a2b1c9682c7beeb26ac0c"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/appmakes/Rai/releases/download/v#{version}/rai-aarch64-linux-gnu.tar.gz"
      sha256 "d4bc73e23f1b1f5f93cde5269d5856a3f8e62dc913190191bdd5b504168a33d9"
    else
      url "https://github.com/appmakes/Rai/releases/download/v#{version}/rai-x86_64-linux-gnu.tar.gz"
      sha256 "7b16df07ab6d38f26d257edf424278d51c07e932be8dfeba94ee8448c0bfaa29"
    end
  end

  def install
    bin.install "rai"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rai --version")
  end
end
