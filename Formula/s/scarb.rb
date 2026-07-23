class Scarb < Formula
  desc "Cairo package manager"
  homepage "https://docs.swmansion.com/scarb/"
  url "https://github.com/software-mansion/scarb/archive/refs/tags/v2.19.4.tar.gz"
  sha256 "cf98cc6a64de0748cf844de765a3eca775c27a4ce970b862eae3edef6714947c"
  license "MIT"
  head "https://github.com/software-mansion/scarb.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "23514f47781b61b15acaf71449444262adbbbb88e17af66dda7b519e5fc22537"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b453097ade17ca97ae3e8f3017b4f51e7e4929eecfbd502a3ee06bf14c379959"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "60cd2db133c685aab7af8af4125b02c0c08f07874602ba3923a982cd0a61b691"
    sha256 cellar: :any_skip_relocation, sonoma:        "8d7c75dcb9d33970d6c76fb37717c03260af70c1cf16d66269a2720c05834260"
    sha256 cellar: :any,                 arm64_linux:   "c4f400ff544d8d75a283928130e237ba76b8b6ad71697c60341943acfa9e8554"
    sha256 cellar: :any,                 x86_64_linux:  "d7ac8db4a2cf14cfaea3b7c76cff9ea624d1acc7b5d8f5ceddf977c5987c7c5b"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    %w[
      scarb
      extensions/scarb-cairo-language-server
      extensions/scarb-cairo-test
      extensions/scarb-doc
    ].each do |f|
      system "cargo", "install", *std_cargo_args(path: f)
    end

    generate_completions_from_executable(bin/"scarb", "completions", shell_parameter_format: :clap)
  end

  test do
    ENV["SCARB_INIT_TEST_RUNNER"] = "none"

    assert_match "#{testpath}/Scarb.toml", shell_output("#{bin}/scarb manifest-path")

    system bin/"scarb", "init", "--name", "brewtest", "--no-vcs"
    assert_path_exists testpath/"src/lib.cairo"
    assert_match "brewtest", (testpath/"Scarb.toml").read

    assert_match version.to_s, shell_output("#{bin}/scarb --version")
    assert_match version.to_s, shell_output("#{bin}/scarb cairo-test --version")
    assert_match version.to_s, shell_output("#{bin}/scarb doc --version")
  end
end
