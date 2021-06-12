class WpCliCompletion < Formula
  desc "Bash completion for Wpcli"
  homepage "https://github.com/wp-cli/wp-cli"
  url "https://github.com/wp-cli/wp-cli/archive/v2.5.0.tar.gz"
  sha256 "cf74ec4f5d6eecc36ea96be294d5620c1b155c00faea3fb459ef9d651c714f66"
  license "MIT"
  head "https://github.com/wp-cli/wp-cli.git"

  def install
    bash_completion.install "utils/wp-completion.bash" => "wp"
  end

  test do
    assert_match "-F _wp_complete",
      shell_output("source #{bash_completion}/wp && complete -p wp")
  end
end
