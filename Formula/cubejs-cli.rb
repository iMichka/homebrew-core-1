require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.26.0.tgz"
  sha256 "8670fb5f9a0f701d3c5c4492ffd6ada0658e41ed856c15857cde33e14742c515"
  license "Apache-2.0"

  livecheck do
    url :stable
  end

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur: "d83a571a687405dbf1c63598723ae1dc315eed61d1455798501791bc28781982"
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "8690e511173bae87ec7e3fd4ad50d23843ae3628c1213fc5cd31ac28fa982822"
    sha256 cellar: :any_skip_relocation, catalina: "f11388ea4f96a84e825f007c3fb934ba3b0af02090aa5f5d10b1b39d9244403b"
    sha256 cellar: :any_skip_relocation, mojave: "05be85207e980c77eb0ae1627c1b92d6cb86f94feed8ba8fbcd39d519627d3c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "6cd606f8cfe5afba9c611422a4525720dd27b43daaf57bf4eaaa7922a1a21ebb"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cubejs --version")
    system "cubejs", "create", "hello-world", "-d", "postgres"
    assert_predicate testpath/"hello-world/schema/Orders.js", :exist?
  end
end
