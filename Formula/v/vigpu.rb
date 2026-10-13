class Vigpu < Formula
  desc "Simple, pretty GPU monitoring TUI"
  homepage "https://seon.uk/vigpu/"
  url "https://github.com/snkii/vigpu/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "2f3e8298cd4c2163cfa8fa332f61f5743959cd042e6d2d4830d76a34dcff4efb"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "rust" => :build

  on_macos do
    depends_on arch: :arm64
  end

  def install
    system "cargo", "install", *std_cargo_args
    libexec.install bin/"vigpu" => "vigpu"
    (bin/"vigpu").write_env_script libexec/"vigpu", VIGPU_NO_UPDATE: "1"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vigpu --version")
  end
end
