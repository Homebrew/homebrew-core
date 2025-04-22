class TechnitiumLibrary < Formula
  desc "Library for technitium .net based applications"
  homepage "https://technitium.com"
  url "https://github.com/TechnitiumSoftware/TechnitiumLibrary/archive/refs/tags/dns-server-v13.5.0.tar.gz"
  sha256 "8e0f3200ad6ee6a1ab346a7224a1bc538f6b3dc1b660cd8bb725d0dc09fa2bf9"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ec851157536a44fd5d308a20ea095be18790f0532973072dc00bbcf34a76c192"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9e08722a6396e8a695202789ed5db5949594e8386b2b1ac5171a90696bd36a65"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "38d3dbdca7ad114282e27a3b3a7b08bd34ab9e5b1afdba0bfcb0e5d041aa8753"
    sha256 cellar: :any_skip_relocation, ventura:       "c072c54bbd09d645d0c01864681ab22434bb3b9d27d2d039a2be3fde872a02e4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "78c410d3a32eadd810ff4b2f55876388987c96bfdcfdbd9e80fd65e346dc9073"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aff4ab8e47c10b2674a6a1af0b698f5016cd5b4cc1aeaba975a1499310266080"
  end

  depends_on "dotnet@8"

  def install
    ENV["DOTNET_CLI_TELEMETRY_OPTOUT"] = "1"

    dotnet = Formula["dotnet@8"]
    args = %W[
      --configuration Release
      --framework net#{dotnet.version.major_minor}
      --no-self-contained
      --output #{libexec}
      --use-current-runtime
    ]

    system "dotnet", "publish", "TechnitiumLibrary.ByteTree/TechnitiumLibrary.ByteTree.csproj", *args
    system "dotnet", "publish", "TechnitiumLibrary.Net/TechnitiumLibrary.Net.csproj", *args
  end

  test do
    dotnet = Formula["dotnet@8"]
    target_framework = "net#{dotnet.version.major_minor}"

    (testpath/"test.cs").write <<~CSHARP
      using System;
      using TechnitiumLibrary;

      namespace Homebrew
      {
        public class TechnitiumLibraryTest
        {
          public static void Main(string[] args)
          {
            Console.WriteLine(Base32.ToBase32HexString(new byte[] { 1, 2, 3 }));
          }
        }
      }
    CSHARP

    (testpath/"test.csproj").write <<~XML
      <Project Sdk="Microsoft.NET.Sdk">
        <PropertyGroup>
          <OutputType>Exe</OutputType>
          <TargetFrameworks>#{target_framework}</TargetFrameworks>
          <PlatformTarget>AnyCPU</PlatformTarget>
          <RootNamespace>Homebrew</RootNamespace>
          <PackageId>Homebrew.Dotnet</PackageId>
          <Title>Homebrew.Dotnet</Title>
          <Product>$(AssemblyName)</Product>
          <EnableDefaultCompileItems>false</EnableDefaultCompileItems>
        </PropertyGroup>
        <ItemGroup>
          <Compile Include="test.cs" />
        </ItemGroup>
        <ItemGroup>
          <Reference Include="TechnitiumLibrary">
            <HintPath>#{libexec}/TechnitiumLibrary.dll</HintPath>
          </Reference>
        </ItemGroup>
      </Project>
    XML

    system "#{dotnet.opt_libexec}/dotnet", "build", "--framework", target_framework,
           "--output", testpath, testpath/"test.csproj"
    output = shell_output("#{dotnet.opt_libexec}/dotnet run --framework #{target_framework} #{testpath}/test.dll")
    assert_match "04106===", output
  end
end
