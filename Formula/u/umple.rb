class Umple < Formula
  desc "Modeling tool/programming language that enables Model-Oriented Programming"
  homepage "https://www.umple.org"
  url "https://github.com/umple/umple/releases/download/v1.34.0/umple-1.34.0.7242.6b8819789.jar"
  version "1.34.0"
  sha256 "817891ba9299f12bc3753c5902d9d61dc15a80096322aceea5c9996922ace0b5"
  license "MIT"
  version_scheme 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8eaf91b07723485e1efa605144885f6cc322fa313a17c755a94bf98300fc9f91"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8eaf91b07723485e1efa605144885f6cc322fa313a17c755a94bf98300fc9f91"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8eaf91b07723485e1efa605144885f6cc322fa313a17c755a94bf98300fc9f91"
    sha256 cellar: :any_skip_relocation, sonoma:         "8eaf91b07723485e1efa605144885f6cc322fa313a17c755a94bf98300fc9f91"
    sha256 cellar: :any_skip_relocation, ventura:        "8eaf91b07723485e1efa605144885f6cc322fa313a17c755a94bf98300fc9f91"
    sha256 cellar: :any_skip_relocation, monterey:       "8eaf91b07723485e1efa605144885f6cc322fa313a17c755a94bf98300fc9f91"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c6a53686935942ed6d83bda76e1066b94b26641060773126d460d08bf55175b4"
  end

  depends_on "openjdk"

  def install
    filename = File.basename(stable.url)

    libexec.install filename
    bin.write_jar_script libexec/filename, "umple"
  end

  test do
    (testpath/"test.ump").write("class X{ a; }")
    system bin/"umple", "test.ump", "-c", "-"
    assert_predicate testpath/"X.java", :exist?
    assert_predicate testpath/"X.class", :exist?
  end
end
