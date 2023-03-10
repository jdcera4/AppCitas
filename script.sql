GO
CREATE database dbCitas;
SET ANSI_NULLS ON;
GO

USE [dbCitas]
GO
/****** Object:  Table [dbo].[Cita]    Script Date: 23/12/2022 3:12:56 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Cita](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[FechaCita] [date] NOT NULL,
	[Doctor] [nvarchar](50) NOT NULL,
	[idPersona] [int] NOT NULL,
 CONSTRAINT [PK_Cita] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Cita_Motivo]    Script Date: 23/12/2022 3:12:56 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Cita_Motivo](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IdMotivoCita] [int] NOT NULL,
	[IdCita] [int] NOT NULL,
 CONSTRAINT [PK_Cita_Motivo] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MotivoCita]    Script Date: 23/12/2022 3:12:56 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MotivoCita](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[motivo] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_MotivoCita] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Persona]    Script Date: 23/12/2022 3:12:56 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Persona](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[Nombre] [nvarchar](50) NOT NULL,
	[Apellido] [nvarchar](50) NOT NULL,
	[Cedula] [nvarchar](50) NOT NULL,
	[Clave] [nvarchar](50) NULL,
 CONSTRAINT [PK_Persona] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Cita]  WITH CHECK ADD  CONSTRAINT [FK_Cita_Persona1] FOREIGN KEY([idPersona])
REFERENCES [dbo].[Persona] ([id])
GO
ALTER TABLE [dbo].[Cita] CHECK CONSTRAINT [FK_Cita_Persona1]
GO
ALTER TABLE [dbo].[Cita_Motivo]  WITH CHECK ADD  CONSTRAINT [FK_Cita_Motivo_Cita] FOREIGN KEY([IdCita])
REFERENCES [dbo].[Cita] ([Id])
GO
ALTER TABLE [dbo].[Cita_Motivo] CHECK CONSTRAINT [FK_Cita_Motivo_Cita]
GO
ALTER TABLE [dbo].[Cita_Motivo]  WITH CHECK ADD  CONSTRAINT [FK_Cita_Motivo_MotivoCita] FOREIGN KEY([IdMotivoCita])
REFERENCES [dbo].[MotivoCita] ([Id])
GO
ALTER TABLE [dbo].[Cita_Motivo] CHECK CONSTRAINT [FK_Cita_Motivo_MotivoCita]

INSERT INTO [dbo].[Persona]
           ([Nombre]
           ,[Apellido]
           ,[Cedula]
           ,[Clave])
     VALUES
           ('Mateo',	'Morales',	'1152451650',	'12345'),
('Juan',	'Rui<',	'11111','12345'),
('David'	,'Lujan',	'22222',	'12345');


INSERT INTO [dbo].[MotivoCita]
           ([motivo])
     VALUES
           ('Operacion'),
		   ('Resfriado'),
		   ('Revision')


INSERT INTO [dbo].[Cita]
           ([FechaCita]
           ,[Doctor]
           ,[idPersona])
     VALUES
           ('2022-12-30'	,'Mateo',	1),
		   ('2022-12-11',	'Julian',	2),
		   ('2022-11-01',	'Tatiana',	1),
		   ('2022-12-30',	'Juliana',	1);




INSERT INTO [dbo].[Cita_Motivo]
           ([IdMotivoCita]
           ,[IdCita])
     VALUES
           (1,1),
			(2,2),
			(2,3),
			(3,4);


GO
/****** Object:  StoredProcedure [dbo].[SPFunciones]    Script Date: 23/12/2022 3:12:56 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SPFunciones] 
	@Action nvarchar(50) ,
	@Cedula nvarchar(50) ='',
	@Fecha nvarchar(50)=''
	
AS
BEGIN
	if @Action ='citasPersona'
		BEGIN
			select Persona.Nombre,
					Persona.Apellido,
					Persona.Cedula,
					cita.FechaCita,
					cita.Doctor as 'Doctor'	   
			from Persona
				inner join Cita on Cita.idPersona = Persona.id
			where Persona.Cedula = @Cedula
		END

	IF @Action ='citaFecha'
		BEGIN
			Select 
				cita.FechaCita,
				cita.Doctor,
				MotivoCita.motivo
			from Cita
				inner join Cita_Motivo on Cita_Motivo.IdCita = cita.Id
				inner join MotivoCita on MotivoCita.Id = Cita_Motivo.IdMotivoCita
			where cita.FechaCita = @Fecha
		END

		IF @Action ='cantidadMotivo'
		BEGIN
			Select 
				Count(MotivoCita.motivo) as 'cantidad',
				MotivoCita.motivo
			from MotivoCita
				inner join Cita_Motivo on MotivoCita.Id = Cita_Motivo.IdMotivoCita
				inner join Cita on Cita.Id = Cita_Motivo.IdCita
			Group BY MotivoCita.motivo
		END
END



-- exec [dbo].[SPFunciones] 'cantidadMotivo','1152451650','20221230'
GO
/****** Object:  StoredProcedure [dbo].[ValidarPersona]    Script Date: 23/12/2022 3:12:56 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ValidarPersona]
	-- Add the parameters for the stored procedure here
	@Cedula nvarchar(50) ,
	@Clave nvarchar(50)

AS
BEGIN
	SELECT * FROM Persona where Persona.Cedula = @Cedula and  Persona.Clave=@Clave 
END
GO
