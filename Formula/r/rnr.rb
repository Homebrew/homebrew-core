class Rnr < Formula
  desc "Command-line tool to batch rename files and directories"
  homepage "https://github.com/ismaelgv/rnr"
  url "https://github.com/ismaelgv/rnr/archive/refs/tags/v0.5.1.tar.gz"
  sha256 "af35b5d5afab08b01cab345686d7e7d2d37a33d268fa8827a8001c3164ef4722"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ead696a12421df3d41baad88405def5ace489769f59ca597146b27bf5a3b9f07"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9ffd7d93cb60c90658d09a1c81981b1e37d4e196e432bf771b349de3c1edbbe3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "de6e20a87a8b0319cf786bf22beb5b85b2462a54d1047ee08414700402a8de8c"
    sha256 cellar: :any_skip_relocation, sonoma:        "3dc55b0e9239aada148995c0ddb203e1fa8d1e2688e621893bb6b3cd67216dcd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9908bcc18e433a4ac843f67803728012f0b7aee2ea270c8551122fe63ce73074"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bbfe77cc0171480691cfda7170ece2125a3ea477f766e9aa7a0dd82d69745390"
  end

  depends_on "rust" => :build

  def install
    ENV["SHELL_COMPLETIONS_DIR"] = buildpath
    system "cargo", "install", *std_cargo_args

    deploy_dir = Dir["target/release/build/rnr-*/out"].first
    zsh_completion.install "#{deploy_dir}/_rnr" => "_rnr"
    bash_completion.install "#{deploy_dir}/rnr.bash" => "rnr"
    fish_completion.install "#{deploy_dir}/rnr.fish"
  end

  test do
    touch "foo.doc"
    mkdir "one"
    touch "one/foo.doc"

    system bin/"rnr", "regex", "-f", "doc", "txt", "foo.doc", "one/foo.doc"
    refute_path_exists testpath/"foo.doc"
    assert_path_exists testpath/"foo.txt"

    assert_match version.to_s, shell_output("#{bin}/rnr --version")
  end
end
