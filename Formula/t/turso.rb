class Turso < Formula
  desc "Interactive SQL shell for Turso"
  homepage "https://github.com/tursodatabase/turso"
  url "https://github.com/tursodatabase/turso/archive/refs/tags/v0.1.4.tar.gz"
  sha256 "8be7fdd8e5f3c996a038d7676c80829b5414b07c4af14ef7de6219f03835f2d6"
  license "MIT"
  head "https://github.com/tursodatabase/turso.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f13d5f01676d049f414fcaeb363078076e1dd0a37469ce7742bf126a74437b22"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c5f08d0c0a08168a2b768994601cc54f9f77f444bfdd364c19330812d41a0574"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a988b524fba5f59403150414c872765217def89a363965bdfe80a14fe0ef9628"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ddcdec3ba9d36774485ac3deec3e4c7fdadb6eba04116cc87f13443f6b683d83"
    sha256 cellar: :any_skip_relocation, sonoma:        "09a48d301f5c2526ba3b7c1db9d52aee69ce9d066922af8b2ff77b211486a7b4"
    sha256 cellar: :any_skip_relocation, ventura:       "579c5fccd77ac186a0961a7036fa68d5accde33cc4aa6f3b580aef4187a00ee9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "935d2e25c7aa96ac3d984017bda840788ed230044f2cb3d034e90c6bd65768c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2ce01203150d51917cc989058342870aef861353af25f06e87babf05095c537f"
  end

  depends_on "rust" => :build
  uses_from_macos "sqlite" => :test

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tursodb --version")

    # Fails in Linux CI with "Error: I/O error: Operation not permitted (os error 1)"
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

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
