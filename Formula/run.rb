class Run < Formula
  desc "Easily manage and invoke small scripts and wrappers"
  homepage "https://github.com/TekWizely/run"
  url "https://github.com/TekWizely/run/archive/v0.11.1.tar.gz"
  sha256 "18f2d5a61c29b8de5dab9581b46efdd815ea367454acec719108c4f3742375db"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cbb3a0d74561c93a11179e457711d65d15dd7479fb4ced72a58cf4d9d111d96e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cbb3a0d74561c93a11179e457711d65d15dd7479fb4ced72a58cf4d9d111d96e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cbb3a0d74561c93a11179e457711d65d15dd7479fb4ced72a58cf4d9d111d96e"
    sha256 cellar: :any_skip_relocation, ventura:        "74cb2543f28e9729bd267f40f51df0126d6667447315bb54e3941ec2291dde6a"
    sha256 cellar: :any_skip_relocation, monterey:       "74cb2543f28e9729bd267f40f51df0126d6667447315bb54e3941ec2291dde6a"
    sha256 cellar: :any_skip_relocation, big_sur:        "74cb2543f28e9729bd267f40f51df0126d6667447315bb54e3941ec2291dde6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "48058c941d2eb99ecc64c1531dccc16726cca571f23743723ee82445d8d0a954"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-trimpath", "-ldflags", "-w -s", "-o", bin/name
  end

  test do
    text = "Hello Homebrew!"
    task = "hello"
    (testpath/"Runfile").write <<~EOS
      #{task}:
        echo #{text}
    EOS
    assert_equal text, shell_output("#{bin}/#{name} #{task}").chomp
  end
end
