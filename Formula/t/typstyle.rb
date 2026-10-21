class Typstyle < Formula
  desc "Beautiful and reliable typst code formatter"
  homepage "https://typstyle-rs.github.io/typstyle/"
  url "https://github.com/typstyle-rs/typstyle/archive/refs/tags/v0.15.2.tar.gz"
  sha256 "155bf8156a1e8f8c08b0730332a5c77f282e9ff672e0953e1eff1996eff56de3"
  license "Apache-2.0"
  head "https://github.com/typstyle-rs/typstyle.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a17ebdb8ab0396e0e3f0c29c1efd699c67e22377ca69d683c516fc03cd9fc908"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6cad10d9999db070af885baa2884710f786dfec424bade22399511f53e1d132d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8ef964028857aec41521dcb27f4217fb1cc008415a201504cb8496e08401d0c3"
    sha256 cellar: :any,                 arm64_linux:       "7e63e6b0312febe191d1913331b6260513fd6752e702b1ae7e6ed7d5b1ba6c9f"
    sha256 cellar: :any,                 x86_64_linux:      "473795e2b97e205350dba1db093aab06aff7e9c247c7cdb4b7c6eda00b8fd05e"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/typstyle")

    generate_completions_from_executable(bin/"typstyle", "completions")
  end

  test do
    (testpath/"Hello.typ").write("Hello World!")
    system bin/"typstyle", "Hello.typ"

    assert_match version.to_s, shell_output("#{bin}/typstyle --version")
  end
end
