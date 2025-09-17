class Vineflower < Formula
  desc "Java decompiler"
  homepage "https://vineflower.org/"
  url "https://github.com/Vineflower/vineflower/archive/refs/tags/1.11.1.tar.gz"
  sha256 "104df4042023190416bff2ad0e2386ddf7669c6aa585f19b9d965a7f5ca5132b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1cba4e8ecb0595caa54ffac65633de2aa402920b6f26cb381209b2ef8959c996"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "62479a14ae3965038932cdf833ee87a48e50b1db0c767362c82d7b5327f62849"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b54dfedf26ee257ef870b6e6a5b96a84ba6fd96955ab16818c093d7b534d653a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "754e2ce57f9e000ac224811a2fb61c127acb8ca4420e1017faa1d162d4da280d"
    sha256 cellar: :any_skip_relocation, sonoma:        "0db4c09fd07af41914236c4221a59b5e618d3303ea95fc435369813ab8bdda9a"
    sha256 cellar: :any_skip_relocation, ventura:       "49ee9fd5f4021a9d9eb7d91840c99d111c80644fc0c838e7b83a762934c9f5d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5ffc032d554d132c2387490e51c8e11a084d5a31d6d97956c69286b999966355"
  end

  # Issue ref: https://github.com/Vineflower/vineflower/issues/495
  depends_on "gradle@8" => :build
  depends_on "openjdk"

  def install
    system "gradle", "build", "-x", "test"

    version_suffix = ENV["GITHUB_ACTIONS"] ? "" : "+local"
    jar = Dir["build/libs/vineflower-#{version}#{version_suffix}.jar"].first
    libexec.install jar => "vineflower.jar"

    bin.write_jar_script libexec/"vineflower.jar", "vineflower"
  end

  test do
    (testpath/"FooBar.java").write <<~JAVA
      public class FooBar {
        public static void bar() {}
        public static void foo() {
          bar();
        }
      }
    JAVA

    system Formula["openjdk"].bin/"javac", "FooBar.java"
    refute_includes shell_output("#{bin}/vineflower FooBar.class"), "error"
  end
end
