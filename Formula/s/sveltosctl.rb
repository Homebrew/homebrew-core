class Sveltosctl < Formula
  desc "Sveltos command-line interface"
  homepage "https://projectsveltos.github.io/sveltos/latest/getting_started/sveltosctl/sveltosctl/"
  url "https://github.com/projectsveltos/sveltosctl.git",
      tag: "v1.3.1",
      revision: "56022d6c1384d4e901c5cd64fbf510144735ce7f"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  depends_on "bash" => :build
  depends_on "go" => :build

  uses_from_macos "rsync" => :build

  on_macos do
    depends_on "coreutils" => :build
  end

  def install
    ENV.prepend_path "PATH", Formula["coreutils"].libexec/"gnubin" if OS.mac?
    ENV["FORCE_HOST_GO"] = "1"

    system "make", "build"
    bin.install "bin/sveltosctl"
  end

  test do
    output = shell_output("#{bin}/sveltosctl version 2>&1")
    assert_match "Client Version:", output
  end
end
