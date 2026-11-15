class Slumber < Formula
  desc "Terminal-based HTTP/REST client"
  homepage "https://slumber.lucaspickering.me/"
  url "https://github.com/LucasPickering/slumber/archive/refs/tags/v5.4.4.tar.gz"
  sha256 "11341547a1c79711cf5fe270abe0a6c4c724c87a9fb34f702c01486adb77bdd9"
  license "MIT"
  head "https://github.com/LucasPickering/slumber.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b36f2aea3feb3c68efc28822100d09c829b513d1e05d99462b78874d96223965"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "54da5a2aa7753d3df6eddb04bb8aff181fb6d26637afa797fe965ef9eb0953af"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b7b2995c220a77bc97532c8742719001b0483f739c0842f26ae548f5b0021acf"
    sha256 cellar: :any,                 arm64_linux:       "8fb15cd08255a058f9f53dd9e01ac6242dfd28de4db198d6c783d39075737eeb"
    sha256 cellar: :any,                 x86_64_linux:      "e0f9162f56a8d9a1264f50cb244b704c371c9c564c7e901afcafd2559c25357f"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"slumber", shell_parameter_format: :clap)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/slumber --version")

    system bin/"slumber", "new"
    assert_match <<~YAML, (testpath/"slumber.yml").read
      profiles:
        example:
          name: Example Profile
          data:
            host: https://my-host
    YAML
  end
end
