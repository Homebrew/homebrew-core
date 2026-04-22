class TomlBombadil < Formula
  desc "Dotfile manager with templating"
  homepage "https://github.com/oknozor/toml-bombadil"
  url "https://github.com/oknozor/toml-bombadil/archive/refs/tags/4.2.0.tar.gz"
  sha256 "b911678642a1229908dfeabbdd7f799354346c0e37f3ac999277655e01b6f229"
  license "MIT"
  head "https://github.com/oknozor/toml-bombadil.git", branch: "main"

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_tahoe:   "a5312af9bf7cb58f95099a46733121f61259c40bef05749b57ce1a3be7f8192d"
    sha256 cellar: :any,                 arm64_sequoia: "a6ed8b993f4cbaf76727c36a1f27996f8f0713ebe3e2a902ad3e8fdfa953c8bb"
    sha256 cellar: :any,                 arm64_sonoma:  "21429cf57a08fa53ff0b75b4e54d3e64d3cb1ce642c87e3885358e31ccd91495"
    sha256 cellar: :any,                 sonoma:        "bf60b11d72eeb4e799e2b096f72593d76ddc9b7c2f240140d1e47ef2205cc691"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8066d1d03de5d940d4782c63f8e060a8e325efef99de59c057c956be6d809287"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dbfc4c1f304f6a32a8106a2a57164220133f4266ef87d0955fc26e154124f4c6"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"bombadil", "generate-completions")
  end

  test do
    config_dir = if OS.mac?
      testpath/"Library/Application Support"
    else
      testpath/".config"
    end

    (config_dir/"bombadil.toml").write <<~TOML
      dotfiles_dir = "dotfiles"
    TOML

    (testpath/"dotfiles").mkpath

    output = shell_output("#{bin}/bombadil get vars")

    assert_match(/"arch":\s*".+"/, output)
    assert_match(/"os":\s*".+"/, output)
  end
end
