class Svcat < Formula
  desc "Kubernetes Service Catalog CLI"
  homepage "https://github.com/Azure/service-catalog-cli"
  url "https://github.com/Azure/service-catalog-cli/archive/v0.2.1.tar.gz"
  sha256 "47d77c644f420f9889df6ef2851a24d32418f1eb7077ab09e2638e6e46e4079a"

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    (buildpath/"src/github.com/Azure/service-catalog-cli").install buildpath.children

    cd "src/github.com/Azure/service-catalog-cli" do
      system "make", "build", "VERSION=#{version}"
      bin.install "bin/svcat"
      prefix.install_metafiles
    end
  end

  test do
    system "#{bin}/svcat", "version"
  end
end
