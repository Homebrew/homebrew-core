class Td < Formula
  desc "Your todo list in your terminal"
  homepage "https://github.com/Swatto/td"
  url "https://github.com/Swatto/td/archive/1.4.0.tar.gz"
  sha256 "b8080a73b274c201bc1fadaf5b83e5fab26b38838f4c82b49f1ae5dadaa94c20"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:     "42d31fcb00186c05db503b8bd8468a66ff61bb66d14ca286a07c158cd1a23511"
    sha256 cellar: :any_skip_relocation, catalina:    "e2fdce36bbab98d388fcc14c448ba87cb4cb77e10a5e20f083128c8cfa2ad367"
    sha256 cellar: :any_skip_relocation, mojave:      "b77b89e4f9b100d834c786d0e60c17aa80a51ed452ffab032589837c11c00714"
    sha256 cellar: :any_skip_relocation, high_sierra: "91a8beaacb3c67dff0dd12a717c10868df7874d9668a043eb658be4eb180390a"
    sha256 cellar: :any_skip_relocation, sierra:      "55f7d879795bcf5cde8af98b463f4751c6c5426ceed96a46a0c1531b1324a60f"
    sha256 cellar: :any_skip_relocation, el_capitan:  "e740be06065aac7f578e47d0bbf6ef803993a6246d0d7fa74c90367b5f3ea080"
    sha256 cellar: :any_skip_relocation, yosemite:    "e608e79004fe1cfbefb2f9963ed4a4e86aad8e8c751e12a97ff3a03325bddd2b"
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GOBIN"] = bin
    (buildpath/"src/github.com/Swatto/td").install buildpath.children
    cd "src/github.com/Swatto/td" do
      system "go", "install"
      prefix.install_metafiles
    end
  end

  test do
    (testpath/".todos").write "[]\n"
    system "#{bin}/td", "a", "todo of test"
    todos = (testpath/".todos").read
    assert_match "todo of test", todos
    assert_match "pending", todos
  end
end
