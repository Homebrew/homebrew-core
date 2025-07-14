class Smug < Formula
  desc "Automate your tmux workflow"
  homepage "https://github.com/ivaaaan/smug"
  url "https://github.com/ivaaaan/smug/archive/refs/tags/v0.3.7.tar.gz"
  sha256 "334c4f885674325dada3dc09c0a0608dc778af9e08377cb9afd3fc2dbf146be7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c88e9162f9c3852ab55add3ef19c595488db86188d2e6ae3e999ba256a3d7281"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c88e9162f9c3852ab55add3ef19c595488db86188d2e6ae3e999ba256a3d7281"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c88e9162f9c3852ab55add3ef19c595488db86188d2e6ae3e999ba256a3d7281"
    sha256 cellar: :any_skip_relocation, sonoma:        "7e13993f4a136cfeaf29ebd9fe8e0f0586e16fee26fe20b382b3a67310a0bf54"
    sha256 cellar: :any_skip_relocation, ventura:       "7e13993f4a136cfeaf29ebd9fe8e0f0586e16fee26fe20b382b3a67310a0bf54"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "969f5675a11d65352c9bbf03ce0e0969886ba069c2ccfdad5ec83b853705e543"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")

    bash_completion.install "completion/smug.bash" => "smug"
    fish_completion.install "completion/smug.fish"
  end

  test do
    (testpath/".config/smug/test.yml").write <<~YAML
      session: homebrew-test-session
      root: .
      windows:
        - name: test
    YAML

    assert_equal(version, shell_output(bin/"smug").lines.first.split("Version").last.chomp)

    begin
      output_log = testpath/"output.log"
      pid = spawn bin/"smug", "start", "--file", testpath/".config/smug/test.yml", [:out, :err] => output_log.to_s
      sleep 2
      assert_match "Starting a new session", output_log.read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
