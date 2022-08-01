class Teller < Formula
  desc "Secrets management tool for developers built in Go"
  homepage "https://tlr.dev/"
  url "https://github.com/SpectralOps/teller.git",
      tag:      "v1.5.3",
      revision: "f7f686544190265db41a2af7bd3313f94d67c880"
  license "Apache-2.0"
  head "https://github.com/SpectralOps/teller.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1797fe5bd80bdefea36ded9e5ff5ce898f20aa23424257889b7134c54af488e3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0109392ce1cf4d1a63f41ae30af458f148a96f873d77bab65e74dd30122ecbaa"
    sha256 cellar: :any_skip_relocation, monterey:       "c62c955d040ac9af69412a1e9b4a8bbb25df70064d117b9c711945d1c8c9173f"
    sha256 cellar: :any_skip_relocation, big_sur:        "b5652d3bd5ddf5369431151491dda9a7f5072cc636adb57fc1da460c47f50d6a"
    sha256 cellar: :any_skip_relocation, catalina:       "828cad98d1457c084550dcd8861a153ca9e9127f690a5c65370992eafd6b3523"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "98616457ce6353995ca016e02f8f786ec5f99dede4b7e4e793323221b2204483"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{Utils.git_head}
      -X main.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    (testpath/"test.env").write <<~EOS
      foo: var
    EOS

    (testpath/".teller.yml").write <<~EOS
      project: brewtest
      providers:
        # this will fuse vars with the below .env file
        # use if you'd like to grab secrets from outside of the project tree
        dotenv:
          env_sync:
            path: #{testpath}/test.env
    EOS

    output = shell_output("#{bin}/teller -c #{testpath}/.teller.yml show  2>&1")
    assert_match "teller: loaded variables for brewtest using #{testpath}/.teller.yml", output
    assert_match "foo", output

    assert_match "Teller #{version}", shell_output("#{bin}/teller version")
  end
end
