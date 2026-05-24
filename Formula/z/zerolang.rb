class Zerolang < Formula
  desc "Programming language for agents with explicit effects and predictable memory"
  homepage "https://zerolang.ai/"
  url "https://github.com/vercel-labs/zero/archive/refs/tags/v0.1.4.tar.gz"
  sha256 "97d1cd93fcbb654c88b48435c8ce02e07ac3b57e2ddf1d8d0549681a0695b051"
  license "Apache-2.0"
  head "https://github.com/vercel-labs/zero.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "da1cfa5aca3344756822c28dc22498afbb7154614e9491dc9c5ef2bc7cef9016"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e33138bae9a70b0d1ebe60bf037af026a4e1b1392608a8ef7f5d7be09e1dbb6c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "032262ceefe35d4ea4dfaefa812b7dc52fb196f52af1358157dbe85c0ea68fda"
    sha256 cellar: :any_skip_relocation, sonoma:        "4de78f2a38a57bcb28ccca908dc3d7a16c6208812a386e43b9b3234443274c5a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9e6d401a21f4705dfb6833efc1e3aefac4c77b676ea2e61a3039577d7270d43b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d28835d6e392a2899069c9247bd2be90226aad08f2eb064987991f481acce1d9"
  end

  def install
    system "make", "-C", "native/zero-c", "OUT=#{bin}/zero"
    rm bin/"zero.build"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/zero --version")

    (testpath/"hello.0").write <<~'ZERO'
      pub fun main(world: World) -> Void raises {
          check world.out.write("hello\n")
      }
    ZERO
    system bin/"zero", "check", testpath/"hello.0"
  end
end
