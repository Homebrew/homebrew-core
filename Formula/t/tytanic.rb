class Tytanic < Formula
  desc "Test runner for Typst projects"
  homepage "https://typst-community.github.io/tytanic/"
  url "https://github.com/typst-community/tytanic/archive/refs/tags/v0.4.1.tar.gz"
  sha256 "9acdf96fba301efb4b92cf5b67f6a2b454315aaf3aea79c0a68a13644b2881a8"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/typst-community/tytanic.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9a143b2ac2140381bbff172b216a4ae8fd3bd46622858dd833d04fd55869bbfa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0c52a116b804e44b808bf762c80b0a725f32ff437526e34c9561bbaf8128610a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d693bb6f2c6329063a431f20ddab37cadaffaeb725eb3a0015d0f10aa3c2677d"
    sha256 cellar: :any_skip_relocation, sonoma:        "8e1a4b7526872328d7ccbec74d61d514a67169d09428afa834746ed4b8ca68df"
    sha256 cellar: :any,                 arm64_linux:   "06d7d392f2352782b919ba3c88c3e746552d565803e19707515b90d24c3152d4"
    sha256 cellar: :any,                 x86_64_linux:  "a87461b1030948f5d2df34bc88b138727d1b1ae15dbb06e89545d12a9f9833c2"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@4"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/tytanic")

    system bin/"tt", "util", "manpage", man1
    generate_completions_from_executable(bin/"tt", "util", "completion")
  end

  test do
    (testpath/"typst.toml").write <<~TOML
      [package]
      name = "test"
      version = "0.1.0"
      entrypoint = "src/lib.typ"
    TOML
    (testpath/"src").mkpath
    (testpath/"src/lib.typ").write "#let hello() = [Hello World!]\n"

    system bin/"tt", "new", "hello", "--root", testpath
    system bin/"tt", "run", "hello", "--root", testpath

    assert_path_exists testpath/"tests/hello/ref/1.png"
    assert_match version.to_s, shell_output("#{bin}/tt --version")
  end
end
