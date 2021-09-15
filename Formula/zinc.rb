class Zinc < Formula
  desc "Stand-alone version of sbt's Scala incremental compiler"
  homepage "https://github.com/typesafehub/zinc"
  url "https://downloads.typesafe.com/zinc/0.3.15/zinc-0.3.15.tgz"
  sha256 "5ec4df3fa2cbb271d65a5b478c940a9da6ef4902aa8c9d41a76dd253e3334ca7"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "86fb3d24eab6f75b51641311d7f9f574a31878f1c93ec1af0938ae2428178cc5"
  end

  deprecate! date: "2018-06-10", because: :repo_archived

  depends_on "openjdk@11"

  def install
    rm_f Dir["bin/ng/{linux,win}*"]
    libexec.install Dir["*"]
    (bin/"zinc").write_env_script libexec/"bin/zinc", Language::Java.overridable_java_home_env("11")
  end

  test do
    system "#{bin}/zinc", "-version"
  end
end
