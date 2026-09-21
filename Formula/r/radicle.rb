class Radicle < Formula
  desc "Sovereign code forge built on Git"
  homepage "https://radicle.xyz"
  url "https://files.radicle.xyz/releases/latest/heartwood-1.10.3.tar.gz"
  sha256 "011bd76d05328438f6c53a06f8952f1ef03fb4dc9ad47adb00190361cd1fd364"
  license all_of: ["MIT", "Apache-2.0"]

  livecheck do
    url "https://files.radicle.xyz/releases/latest/radicle.json"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d6081e218c21ccbf474b4eba38f71e5e450c7f208d18a828faf3180f4ee7ac96"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "050d509c4ea0d0ae41f526ed33308f1417e172190e99e9373cb3dc2527f15cb1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2a21583b757ddec1183f0374a9d16cd240bcccfa0949b54c1bd5100797cb1a2a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "eb9e7c117f244fffb2c28db76dcd4ca4fdd013808dfd52f98315de3868608d67"
    sha256 cellar: :any,                 arm64_linux:       "25f5f050e0d9dad92fee9fdda37983108770c1ac3b47bc8b1152dfbfb70ee5bc"
    sha256 cellar: :any,                 x86_64_linux:      "0f4c3462abb595663497cee57750da116be7eb3b2e55ecdcbffccacba6ea74d7"
  end

  depends_on "asciidoctor" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssh"
    depends_on "zlib-ng-compat"
  end

  def install
    ENV["RADICLE_VERSION"] = version.to_s

    %w[radicle-cli radicle-node radicle-remote-helper].each do |bin|
      system "cargo", "install", *std_cargo_args(path: "crates/#{bin}")
    end

    generate_completions_from_executable(bin/"rad", "completion")

    system "asciidoctor", "-b", "manpage", "-d", "manpage", "*.1.adoc"
    man1.install Dir["*.1"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rad version")
    assert_match version.to_s, shell_output("#{bin}/radicle-node --version")

    assert_match "Your Radicle DID is", pipe_output("#{bin}/rad auth --alias homebrew --stdin", "homebrew", 0)
    assert_match "\"repos\": 0", shell_output("#{bin}/rad stats")
    system bin/"rad", "ls"

    assert_match "a passphrase is required", shell_output(bin/"radicle-node", 1)
  end
end
