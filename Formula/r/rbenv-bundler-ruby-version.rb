class RbenvBundlerRubyVersion < Formula
  desc "Pick a ruby version from bundler's Gemfile"
  homepage "https://github.com/aripollak/rbenv-bundler-ruby-version"
  url "https://github.com/aripollak/rbenv-bundler-ruby-version/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "96c6b7eb191d436142fef0bb8c28071d54aca3e1a10ca01a525d1066699b03f2"
  license "Unlicense"
  revision 1
  head "https://github.com/aripollak/rbenv-bundler-ruby-version.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "a8b7118dff025b078c5ad1206cc616e5bf436faf1516dbaad4c38a18e31bb0b6"
  end

  depends_on "rbenv"

  def install
    prefix.install Dir["*"]
  end

  test do
    (testpath/"Gemfile").write("ruby \"2.1.5\"")
    system "rbenv", "bundler-ruby-version"
  end
end
