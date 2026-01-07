class Turso < Formula
  desc "Interactive SQL shell for Turso"
  homepage "https://github.com/tursodatabase/turso"
  url "https://github.com/tursodatabase/turso/archive/refs/tags/v0.4.2.tar.gz"
  sha256 "778600a599646e30fc60c000d2b64deab8078f482e1d270d03ebdf8b57d2ab48"
  license "MIT"
  head "https://github.com/tursodatabase/turso.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ad0d62c1d75c47f14528850203753be9afca92515c9d854a928c71ce3df730ba"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fb807b8c7c07c4484fbbe8b0f49ce719dd043fc63c99bebdd96d143b56fac885"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2394c51edc692232157564e664aed0a2e57681fb2064867e82fb321bf91e813d"
    sha256 cellar: :any_skip_relocation, sonoma:        "61e1a22c25ff297452a75a9918c00817b8f3e7a6fd3ca44a8dcdffb9a2c8b77b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "701b1bb4edcae8fc1b74289f31eba12d51b7c08915c1c2420a4066f2b90d7329"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "736440df08755f57554b39364e1f90bf280c73d1ad04be483f6eb6be8f717006"
  end

  depends_on "rust" => :build
  uses_from_macos "sqlite" => :test

  on_arm do
    on_linux do
      depends_on "llvm" => :build
    end

    fails_with :gcc do
      version "12"
      cause "error: inlining failed in call to 'always_inline' 'veor3q_u8'"
    end
  end

  def install
    ENV.llvm_clang if OS.linux? && Hardware::CPU.arm?
    system "cargo", "install", *std_cargo_args(path: "cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tursodb --version")

    data = %w[Bob 14 Sue 12 Tim 13]
    create = "create table students (name text, age integer);\n"
    data.each_slice(2) do |n, a|
      create << "insert into students (name, age) values ('#{n}', '#{a}');\n"
    end
    pipe_output("sqlite3 school.sqlite", create, 0)

    begin
      output_log = testpath/"output.log"
      pid = spawn bin/"tursodb", "school.sqlite", [:out, :err] => output_log.to_s
      sleep 2
      assert_match "\".help\" for usage hints.", output_log.read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
