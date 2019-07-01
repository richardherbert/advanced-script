<cfoutput><div >
	<div>
		<h1>Password Reset</h1>

		#getInstance( 'messagebox@cbmessagebox' ).renderIt()#

		<form action="#event.buildLink( 'signin.passwordresetaction.token.#rc.token#' )#" method="POST">
			<div>
				<label for="password">New password</label>

				<input id="password" name="password" type="password" autofocus required>
			</div>

			<div>
				<label for="passwordConfirm">Confirm password</label>

				<input id="passwordConfirm" name="passwordConfirm" type="password" required>
			</div>

			<button type="submit">Reset password</button>
		</form>
	</div>
</div></cfoutput>
