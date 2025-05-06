class TechnitiumLibrary < Formula
  desc "Library for technitium .net based applications"
  homepage "https://technitium.com"
  url "https://github.com/TechnitiumSoftware/TechnitiumLibrary/archive/refs/tags/dns-server-v13.6.0.tar.gz"
  sha256 "b191357282562662b11563d80476d18061e7cb7adf6d5b0637e012c5e961faae"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7e4cb83b00dd9588bf345937b4221fd0b8c5e12ba18f149ff5de729bc6df4334"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "28984faece182530989be911c65002be59e1ed4a8a828d10ce834223af4ce65d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a130d29c1e2c741cf0d27b613d0b73196ea28f72027d20d26d787c4d2a7a8357"
    sha256 cellar: :any_skip_relocation, ventura:       "d6ca1c337f27ceb3c4019a9cdd99872667f6ae3e7d4c5ea7d3db76ad69411461"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e5d4297401a01a142b864d51d70fbc4726a6c5e93d802a59b67c404c0431cd13"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b1a8b06b6c37b37f17a0f6ef36e5ff08ff9c5a32089b69b1f7be8695fe0acc35"
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
