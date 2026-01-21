class Sk < Formula
  desc "Fuzzy Finder in rust!"
  homepage "https://github.com/skim-rs/skim"
  url "https://github.com/skim-rs/skim/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "ef785dc99275190f0985ab33b24b7ff8f9681cb68f05c0e16a6d6a79b3f8fc39"
  license "MIT"
  head "https://github.com/skim-rs/skim.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5aeab2711fd402bc4bf7d82265da2fca6213d80e7a69aa92aa88fa426071e31a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "68435c5304bbc2cc2baeb2703a3ff93042fd704ab6facd49c0bff123cf8308e8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b630331001f8b994f4966bd10fdc97fd85e38fb8267dddda80605fe1ad59c8f8"
    sha256 cellar: :any_skip_relocation, sonoma:        "4236d7c300104b74a2f8667b1cb1d8f8dac8316d69ad6a7b68da91a9fd137c39"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9d88238713751a0f4425eb7111d970859fbb19510753f460b6430e841037e670"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "150949f6e135e954d6025110a33f6a1dc5f87c2f301377ce404468e99be98c86"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"sk", "--shell")
    bash_completion.install "shell/key-bindings.bash"
    fish_completion.install "shell/key-bindings.fish" => "skim.fish"
    zsh_completion.install "shell/key-bindings.zsh"
    man1.install buildpath.glob("man/man1/*.1")
    bin.install "bin/sk-tmux"
  end

  test do
    assert_match(/.*world/, pipe_output("#{bin}/sk -f wld", "hello\nworld"))
  end
end
