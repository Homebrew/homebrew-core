class Rnr < Formula
  desc "Command-line tool to batch rename files and directories"
  homepage "https://github.com/ismaelgv/rnr"
  url "https://github.com/ismaelgv/rnr/archive/refs/tags/v0.4.2.tar.gz"
  sha256 "cde8e5366552263300e60133b82f6a3868aeced2fe83abc91c2168085dff0998"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "045c120169513225fc0c3531e0219281d5b1792044e58d25d9ad88836e6c308e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "19f9b96c9c53acc4ccc2296ebf16a3a6c51c1c0d0ee16fb6562c02953d52ccb4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9616602a7538bba0f49e591397929ddb51c20aa4d5a53448ffe68d1d83eb1a68"
    sha256 cellar: :any_skip_relocation, ventura:        "fe59ad75b5e4b1d82592dd06d30ccaaecfb59f9bae95ddf14965f8f0a93a52e9"
    sha256 cellar: :any_skip_relocation, monterey:       "15db3a1e56b74e017e5777d6e6b3ae4b0b662f0d7ae18633609e735b30ddde90"
    sha256 cellar: :any_skip_relocation, big_sur:        "ba2390fcebc3cf0787e30d462ff0be92feb33a36d8a3e9752b121f4dfbfb820e"
    sha256 cellar: :any_skip_relocation, catalina:       "e6a201e62a179608041e1fd5ed23386a025119d4de702e99411d5017511862e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4248e01e2710b44632164c3644f6b88c43cd4813e9f07402b2c47347d40eb7f8"
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

    system "#{bin}/rnr", "-f", "doc", "txt", "foo.doc", "one/foo.doc"
    refute_predicate testpath/"foo.doc", :exist?
    assert_predicate testpath/"foo.txt", :exist?
  end
end
