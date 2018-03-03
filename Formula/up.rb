require "language/go"

class Up < Formula
  desc "Deploy infinitely scalable serverless apps, apis and sites in seconds to AWS"
  homepage "https://up.docs.apex.sh/"
  url "https://github.com/apex/up/archive/v0.5.5.tar.gz"
  sha256 "f8a123c282c959ea3f7ba4cc0cebbfcd124a7dfd807d34c0f13dcb795ad1b5fb"
  head "https://github.com/apex/up.git"

  depends_on "go" => :build
  depends_on "dep" => :build

  go_resource "github.com/jteeuwen/go-bindata" do
    url "https://github.com/jteeuwen/go-bindata.git",
        :revision => "a0ff2567cfb70903282db057e799fd826784d41d"
  end

  go_resource "github.com/pointlander/peg" do
    url "https://github.com/pointlander/peg.git",
        :revision => "7003d5eb5f7508c492aa4af8270c59fee36c5e5c"
  end

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/apex/up").install buildpath.children

    ENV.prepend_create_path "PATH", buildpath/"bin"
    Language::Go.stage_deps resources, buildpath/"src"

    build_tools = [
      "github.com/jteeuwen/go-bindata/go-bindata",
      "github.com/pointlander/peg",
    ]

    build_tools.each do |tool|
      cd "src/#{tool}" do
        system "go", "get", "."
        system "go", "install"
      end
    end

    cd "src/github.com/apex/up" do
      system "dep", "ensure"
      system "go", "generate", "./..."
      system "go", "install", "-ldflags", "-X main.version=#{version}", "./..."
    end

    bin.install "bin/up"
  end

  test do
    system "#{bin}/up", "version"
  end
end
