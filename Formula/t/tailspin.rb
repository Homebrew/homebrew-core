class Tailspin < Formula
  desc "Log file highlighter"
  homepage "https://github.com/bensadeh/tailspin"
  url "https://github.com/bensadeh/tailspin/archive/refs/tags/5.5.0.tar.gz"
  sha256 "e9d7cefb865585bb048a2ccbfcc1f900ae344134d71132a7c48ee0d5af09cdaf"
  license "MIT"
  head "https://github.com/bensadeh/tailspin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "95494039cb74f12c62c4d37a73dda0cdeffd7289e8d943e3e2886edf0b9202fb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "44586a6dcad6fb8267c8740d76404ad12bf7e089c429247e2ace1c8619277110"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7b72108e7744f6539b7478ef15df4b3e8ca8c3ba20809b4ecdb0cf4ace12d608"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a5a88936ed1623af9aa4560bdce4a641275bf630c06ac380b382fe84e38a2abd"
    sha256 cellar: :any_skip_relocation, sonoma:        "b12c37ddda9f095c000238c85caa5f97045f782fd9f573a859a1268257e1bb3b"
    sha256 cellar: :any_skip_relocation, ventura:       "38be0ff04c8a3539a1e5f93339f2e3627fa989afc813062e20d1f660669620a4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c9b8c4d226fe1c26a0ceab3934e20a74a252dd839c426dc26dde346336b044b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5aca6beeb105f23fa5564d72ed192d7994351a7faa1c0e89e167472c9dadfe6c"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    bash_completion.install "completions/tspin.bash" => "tspin"
    fish_completion.install "completions/tspin.fish"
    zsh_completion.install "completions/tspin.zsh" => "_tspin"
    man1.install "man/tspin.1"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tspin --version")

    (testpath/"test.log").write("test\n")
    system bin/"tspin", "test.log"
  end
end
