class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://github.com/railwayapp/cli/archive/refs/tags/v5.26.3.tar.gz"
  sha256 "1f528ea224e31c612294fed3da39136e56c435b262fc20d90f176bf3c0728a85"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a5a78f51f4c129b96c1cdf786e3a662e5e950999e0e273d8352ae909f3761abf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7bad5bbc10fdf82f2254fa593c286dd678978584351dd90c2d58db2c3e6cdea6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "185291483bbdd7e30f40d6c9f759fa220a51ef2b041b1a97b31b35bbebb0f9ec"
    sha256 cellar: :any_skip_relocation, sonoma:        "a94ee7b00c9f978311ab286b2726c1735c2edcfcd350e5ff0ef34ffd499550ba"
    sha256 cellar: :any,                 arm64_linux:   "48ec25ab3230dace51295bfe105f55798ac82b43469b01c7e6815e54a9a6709d"
    sha256 cellar: :any,                 x86_64_linux:  "6dcbe4c5f0ff6d7f380bb1ea45e641903a04eb1281d1d12771452d041c0c7a99"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"railway", "completion")
  end

  test do
    output = shell_output("#{bin}/railway init 2>&1", 1).chomp
    assert_match "Unauthorized. Please login with `railway login`", output

    assert_equal "railway #{version}", shell_output("#{bin}/railway --version").strip
  end
end
